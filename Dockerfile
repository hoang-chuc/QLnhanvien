# Dockerfile cho ASP.NET Web Forms (.NET Framework 4.7.2)
# Chay tren Windows Container (yeu cau Docker Desktop voi Windows containers mode)

FROM mcr.microsoft.com/dotnet/framework/aspnet:4.7.2-windowsservercore-ltsc2019

# Thiet lap thu muc lam viec
WORKDIR /inetpub/wwwroot

# Copy source code vao container
COPY . .

# Mo port 80
EXPOSE 80
