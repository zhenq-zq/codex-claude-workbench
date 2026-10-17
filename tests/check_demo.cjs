// Verify actual embedded demo script with a minimal document/storage harness.
const fs=require('node:fs'), vm=require('node:vm'), assert=require('node:assert/strict');
const html=fs.readFileSync(require('node:path').join(__dirname,'../example/index.html'),'utf8');
const script=html.match(/<script>([\s\S]*?)<\/script>/)[1];
const saved=new Map();
function run(failStorage=false){
 const boxes=Array.from({length:3},()=>({checked:false,addEventListener(name,fn){this.change=fn;}}));
 const count={textContent:''},note={textContent:''};
 const ctx={document:{querySelectorAll:()=>boxes,querySelector:s=>s==='#count'?count:note},localStorage:{getItem:k=>{if(failStorage)throw Error('blocked');return saved.get(k)||null},setItem:(k,v)=>{if(failStorage)throw Error('blocked');saved.set(k,v)}}};
 vm.runInNewContext(script,ctx);return {boxes,count,note};
}
let page=run();assert.equal(page.count.textContent,'已完成 0 / 3 件事');
page.boxes[0].checked=true;page.boxes[0].change();assert.equal(page.count.textContent,'已完成 1 / 3 件事');
page=run();assert.equal(page.boxes[0].checked,true);assert.equal(page.count.textContent,'已完成 1 / 3 件事');
page.boxes[0].checked=false;page.boxes[0].change();assert.equal(page.count.textContent,'已完成 0 / 3 件事');
page=run(true);page.boxes[1].checked=true;page.boxes[1].change();assert.equal(page.count.textContent,'已完成 1 / 3 件事');assert.ok(page.note.textContent.includes('不允许保存'));
console.log('Demo: toggle, count, restored state and blocked storage checks passed.');
