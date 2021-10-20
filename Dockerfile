# minimized Dockerfile for a .Net Core sample Dockerfile based on the Alpine Image
# non-root requires the exposed port to be higher 1024
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env

WORKDIR /app
ADD . .
RUN dotnet publish \
  -c Release  -p:PublishTrimmed=true -r linux-x64\
  -o ./output

FROM mcr.microsoft.com/dotnet/runtime-deps:5.0
RUN adduser \
  --disabled-password \
  --home /app \
  --gecos '' app \
  && chown -R app /app
USER app
WORKDIR /app
COPY --from=build-env /app/output .
ENV DOTNET_RUNNING_IN_CONTAINER=true \
  ASPNETCORE_URLS=http://+:8080

EXPOSE 8080
ENTRYPOINT ["./FredApi"]

