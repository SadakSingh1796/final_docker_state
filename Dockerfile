FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copy only the project file to take advantage of caching
COPY ["CurdCountryAndState/CurdCountryAndState.csproj", "CurdCountryAndState/"]
RUN dotnet restore "CurdCountryAndState/CurdCountryAndState.csproj"

# Copy the entire solution and build
COPY . .
WORKDIR "/src/CurdCountryAndState"
RUN dotnet build "CurdCountryAndState.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CurdCountryAndState.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CurdCountryAndState.dll"]
