FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /App

# Copy everything
COPY . ./

## Install Java, because the sonarscanner needs it.
RUN rm -r -f /usr/share/man/man1/
RUN mkdir /usr/share/man/man1/
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y openjdk-11-jre

## Install sonarscanner
RUN dotnet tool install --global dotnet-sonarscanner

## Set the dotnet tools folder in the PATH env variable
ENV PATH="${PATH}:/root/.dotnet/tools"

RUN dotnet sonarscanner begin /k:"jenkintest" /d:sonar.host.url="http://192.168.60.21:30107"  /d:sonar.login="6c8b88f005acf3301f77a67448e07d33de2891ea"

RUN dotnet build

RUN dotnet sonarscanner end /d:sonar.login="6c8b88f005acf3301f77a67448e07d33de2891ea"


# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /App
COPY --from=build-env /App/out .
ENTRYPOINT ["dotnet", "jenkintest.dll"]