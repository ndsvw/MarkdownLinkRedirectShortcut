This project attempts to find all redirect links in a markdown file and replace them with the redirect targets.

## Usage (via Docker)

```
git clone https://github.com/ndsvw/MarkdownLinkRedirectShortcut.git
```

```
cd MarkdownLinkRedirectShortcut
```

```
docker build -t mdlinkredirectshortcut . 
```

```
docker run -v /absolute/local/directory/path:/workdir mdlinkredirectshortcut README.md
```