FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

COPY *.sln ./
COPY MyMinimalApi/*.csproj ./MyMinimalApi/
COPY MyMinimalApi.Test/*.csproj ./MyMinimalApi.Test/
RUN dotnet restore

COPY . ./
WORKDIR /app/MyMinimalApi
RUN dotnet publish -c Release -o /out

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /out .

ENV ASPNETCORE_URLS=http://0.0.0.0:8080

EXPOSE 8080

ENTRYPOINT ["dotnet", "MyMinimalApi.dll"]