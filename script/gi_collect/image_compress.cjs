const sharp = require("sharp");
const fs = require("fs");

for (const file of fs.readdirSync("img")) {
  sharp(`img/${file}`)
    .jpeg({quality: 60})
    .toFile(`img_compress/${file}`, (err, info) => { });
}