const isNode = typeof process !== 'undefined' && process.versions && process.versions.node;
let _fs;
async function fetchCompile (url) {
  if (isNode) {
    _fs = _fs || await import('fs/promises');
    return WebAssembly.compile(await _fs.readFile(url));
  }
  return fetch(url).then(WebAssembly.compileStreaming);
}

const instantiateCore = WebAssembly.instantiate;

function toUint32(val) {
  return val >>> 0;
}


let exports0;

function addNumber(arg0, arg1) {
  const ret = exports0['example:calculator/calculate#add-number'](toUint32(arg0), toUint32(arg1));
  return ret >>> 0;
}

const $init = (() => {
  let gen = (function* init () {
    const module0 = fetchCompile(new URL('./calculator.core.wasm', import.meta.url));
    ({ exports: exports0 } = yield instantiateCore(yield module0));
  })();
  let promise, resolve, reject;
  function runNext (value) {
    try {
      let done;
      do {
        ({ value, done } = gen.next(value));
      } while (!(value instanceof Promise) && !done);
      if (done) {
        if (resolve) resolve(value);
        else return value;
      }
      if (!promise) promise = new Promise((_resolve, _reject) => (resolve = _resolve, reject = _reject));
      value.then(runNext, reject);
    }
    catch (e) {
      if (reject) reject(e);
      else throw e;
    }
  }
  const maybeSyncReturn = runNext(null);
  return promise || maybeSyncReturn;
})();

await $init;
const calculate = {
  addNumber: addNumber,
  
};

export { calculate, calculate as 'example:calculator/calculate',  }