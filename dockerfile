FROM mcr.microsoft.com/dotnet/core/sdk:3.1.201 AS build-env
WORKDIR /app

# Copy everything else and build
COPY . ./
RUN dotnet build

# RUN dotnet publish -c Release -o out
RUN dotnet test

#to run the full project, run the command dotnet 
# RUN --project DevOpsLeadsApi.Api/


ARG BUILD_CONFIGURATION=Debug
ENV ASPNETCORE_ENVIRONMENT=Development
ENV DOTNET_USE_POLLING_FILE_WATCHER=true  
ENV ASPNETCORE_URLS=http://+:5000  

RUN dotnet restore

EXPOSE 5000/tcp

CMD ["dotnet", "run", "--no-restore", "--project", "DevOpsLeadsApi.Api/"]

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
