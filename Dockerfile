#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat 

#FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
#WORKDIR /app
#ARG source
#WORKDIR /inetpub/wwwroot
#COPY ${source:-obj/Docker/publish} .
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1-stretch-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:2.1-stretch AS build
WORKDIR /src
COPY ["SampleDockerApp/SampleDockerApp.csproj", "SampleDockerApp/"]
RUN dotnet restore "SampleDockerApp/SampleDockerApp.csproj"
COPY . .
WORKDIR "/src/SampleDockerApp"
RUN dotnet build "SampleDockerApp.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "SampleDockerApp.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "SampleDockerApp.dll"]
