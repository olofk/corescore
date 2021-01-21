import {
  html,
  render,
  useState,
  useEffect
} from "https://unpkg.com/htm/preact/standalone.module.js";

import yaml from 'https://unpkg.com/js-yaml@4.0.0/dist/js-yaml.mjs?module';

function CoreTable() {
  const [coresList, setCores] = useState([]);
  useEffect(() => {
    fetch("https://raw.githubusercontent.com/olofk/corescore/master/corescore.core", {})
      .then(res => res.text())
      .then(text => {
        let gen = yaml.load(text).generate;
        let cores = []
        for (let [k, v] of Object.entries(gen)) {
          if (v.generator == 'corescorecore') {
            cores.push({board:k.slice(14), score:v.parameters.count});
          }
        }
        cores.sort((a,b) => b.score - a.score);
        setCores(cores);
    });
  }, []);
  return html`
      <table>
        <thead><td>Board</td><td>CoreScore</td></thead>
        ${ coresList.map((c,i) => {
          let color = 'redText';
          if (i < coresList.length * 2 / 3) color = 'yellowText';
          if (i < coresList.length / 3) color = 'blueText';
          return html`<tr class="${color}"><td>${c.board}</td><td style="text-align: center;">${c.score}</td></tr>`
        })}
      </table>`;
}

render(html`<${CoreTable}/>`, document.querySelector('#main'));
