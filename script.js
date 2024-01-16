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
        let targets = yaml.load(text).targets;
        let cores = []

        function countCores(name) {
	  let pcount = 0;
	  let ttptttg = undefined;
	  /* Check if it is a generator with assigned values */
	  if (name instanceof Object) {
	      for (let x in name) {
		  ttptttg = gen[x];
		  pcount = name[x].count;
	      }
	  } else {
      /* Find the referenced generator */
	      ttptttg = gen[name];
	  }

	  /* Check if ttpttttg actually exists */
	  if (typeof ttptttg == 'undefined') {
	      return -1;
	  }
	  /* Check if generator is a corescorecore generator */
	  if (ttptttg.generator !== "corescorecore") {
	      return -1;
	  }

	  if (pcount) {
	      return pcount;
	  } else {
	      return ttptttg.parameters.count;
	  }
      }

         for (let [target_name, target] of Object.entries(targets)) {
         if (target_name === "default") { continue; }
         if (target_name === "sim") { continue; }
         for (let gen_name of target.generate) {
            let x = countCores(gen_name);
            if (x > 0) {
              cores.push({board:target_name, score:x});
            }
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
