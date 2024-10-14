import axios from 'axios';
import { parse } from 'node-html-parser';
import { writeFileSync, createWriteStream } from 'fs';

for (let i=2; i < 14; i++) {
    axios.get(`https://vgcollect.com/search/Game%20informer/${i}`)
        .then(function (response) {

            writeFileSync(`html/${i}.html`, response.data);

            const items = parse(response.data).querySelectorAll(".item");

            for (const item of items) {

                const title = item.querySelector(".item-name>a").innerHTML;

                // Skip if doesn't contain title or has a bracket
                if (title.indexOf("Game Informer") === -1 || title.indexOf("(") !== -1) {
                    continue;
                }

                const number = parseInt(title.split(" ").pop().replace("#", ""), 10);
                const src = item.querySelector(".item-art>a>img").getAttribute("src");

                axios({
                    method: 'get',
                    url: src,
                    responseType: 'stream',
                }).then(function (response) {
                    response.data.pipe(createWriteStream(`img/${number}.jpg`));
                })
                .catch(function (error) {
                    console.log(error);
                });
            }
        })
        .catch(function (error) {
            console.log(error);
        });
}