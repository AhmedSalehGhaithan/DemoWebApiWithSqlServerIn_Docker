#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080
#EXPOSE 8081

#this stage is used to build the service project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["DemoWebApiWithSqlServerInDocker/DemoWebApiWithSqlServerInDocker.csproj", "DemoWebApiWithSqlServerInDocker/"]
RUN dotnet restore "./DemoWebApiWithSqlServerInDocker/DemoWebApiWithSqlServerInDocker.csproj"
COPY . .
WORKDIR "/src/DemoWebApiWithSqlServerInDocker"
RUN dotnet build "./DemoWebApiWithSqlServerInDocker.csproj" -c $BUILD_CONFIGURATION -o /app/build

#this stage is used in publish the service project to be coped to the final stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./DemoWebApiWithSqlServerInDocker.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# this stage is used in production or when running from vs in regular mode (Default when not using the debug configuration )
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DemoWebApiWithSqlServerInDocker.dll"]