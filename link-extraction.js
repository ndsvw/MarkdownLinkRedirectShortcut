const { readFileSync } = require('fs');
const markdownLinkExtractor = require('markdown-link-extractor');

var args = process.argv
if(args.length <= 2)
    throw new Error("need to pass input file...")

const markdown = readFileSync(args[2], {encoding: 'utf8'});

const links = markdownLinkExtractor(markdown).filter(l => l.startsWith("http"))
const uniqueLinks = Array.from(new Set(links))
uniqueLinks.forEach(link => process.stdout.write(link + "\n"));