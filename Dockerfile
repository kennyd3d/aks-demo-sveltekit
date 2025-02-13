FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2022 as build
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Browse https://nodejs.org/dist/
ADD https://nodejs.org/dist/v20.15.1/node-v20.15.1-x64.msi c:/node.msi
RUN Start-Process c:/node.msi -ArgumentList "/qn" -Wait ; \
    Remove-Item c:/node.msi

RUN $env:Path += ';C:/Program Files/nodejs' ; \
    node -v ; \
    npm -v

WORKDIR /app
COPY package.json package.json
RUN npm i
COPY . .
RUN npm run build
EXPOSE 3000
ENTRYPOINT ["node", "./build"]