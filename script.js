const hud=document.getElementById('hud'),speedEl=document.getElementById('speed'),needle=document.getElementById('needle'),rpmEl=document.getElementById('rpm'),fuelEl=document.getElementById('fuel'),hpEl=document.getElementById('hp'),gearEl=document.getElementById('gear'),odoEl=document.getElementById('odo'),engine=document.getElementById('engine'),lights=document.getElementById('lights'),belt=document.getElementById('belt'),left=document.getElementById('left'),right=document.getElementById('right');

const ticks=document.getElementById('ticks'),numbers=document.getElementById('numbers');
for(let i=0;i<=36;i++){let t=document.createElement('i');t.className='tick '+(i%4===0?'major':'');t.style.transform=`rotate(${i*10-135}deg)`;ticks.appendChild(t)}
for(let i=0;i<=9;i++){let n=document.createElement('span');n.textContent=i*20;n.style.setProperty('--rot',`${i*20-90}deg`);numbers.appendChild(n)}

const clamp=(v,a,b)=>Math.max(a,Math.min(b,v));
const active=(el,v)=>el.classList.toggle('active',!!v);

window.addEventListener('message',e=>{
 const d=e.data||{};
 if(d.action==='show')hud.classList.remove('hidden');
 if(d.action==='hide')hud.classList.add('hidden');
 if(d.action==='seatbelt')active(belt,d.value);
 if(d.action==='update'){
   const s=clamp(Number(d.speed)||0,0,180);
   speedEl.textContent=Math.round(s);
   rpmEl.textContent=(clamp(Number(d.rpm)||0,0,1)*8).toFixed(1);
   fuelEl.textContent=Math.round(clamp(Number(d.fuel)||0,0,100));
   hpEl.textContent=Math.round(clamp(Number(d.health)||0,0,100));
   gearEl.textContent=d.gear||'N';
   needle.style.transform=`rotate(${-135+s}deg)`;
   odoEl.textContent=String(Math.floor(s*.01)+1).padStart(4,'0');
   active(engine,d.engine);active(lights,d.highbeam);active(belt,d.seatbelt);
   active(left,d.left);active(right,d.right);
 }
});