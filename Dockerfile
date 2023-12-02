# Use the .NET SDK image for building and publishing
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Set the working directory
WORKDIR /src

# Copy only the project file to take advantage of caching
COPY ["/absolute/path/to/CurdCountryAndState.csproj", "CurdCountryAndState/"]


# Restore dependencies
RUN dotnet restore "CurdCountryAndState/CurdCountryAndState.csproj"

# Copy the entire application
COPY . .

# Build the application
RUN dotnet build "CurdCountryAndState/CurdCountryAndState.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "CurdCountryAndState/CurdCountryAndState.csproj" -c Release -o /app/publish

# Use a smaller runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Set the entry point
ENTRYPOINT ["dotnet", "CurdCountryAndState.dll"]
