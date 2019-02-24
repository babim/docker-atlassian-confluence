# Atlassian Confluence in a Docker container
## (Thanks Martin Aksel Jensen cptactionhank)

## Get me started

To quickly get started running a Confluence instance, use the following command:
```bash
docker run --detach --publish 8090:8090 babim/confluence:latest
```
```
volume:
/var/atlassian/confluence
/opt/atlassian/confluence
```

Then simply navigate your preferred browser to `http://[dockerhost]:8090` and finish the configuration.

## Configuration

You can configure a small set of things by supplying the following environment variables

| Environment Variable   | Description |
| ---------------------- | ----------- |
| X_PROXY_NAME           | Sets the Tomcat Connectors `ProxyName` attribute |
| X_PROXY_PORT           | Sets the Tomcat Connectors `ProxyPort` attribute |
| X_PROXY_SCHEME         | If set to `https` the Tomcat Connectors `secure=true` and `redirectPort` equal to `X_PROXY_PORT`   |
| X_PATH                 | Sets the Tomcat connectors `path` attribute |
