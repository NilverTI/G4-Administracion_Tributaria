/* login.js - Fondo futurista tipo "Opulento" usando Canvas 2D
   Paleta adaptada al sistema: --navy / --accent / bg claro
*/

(() => {
  const canvas = document.getElementById("opulento-bg");
  if (!canvas) return;

  const ctx = canvas.getContext("2d", { alpha: true });
  if (!ctx) return;

  // Año en el footer
  const yearEl = document.getElementById("year");
  if (yearEl) yearEl.textContent = new Date().getFullYear();

  const clamp = (n, a, b) => Math.max(a, Math.min(b, n));

  // DPR retina
  let dpr = Math.max(1, Math.min(2, window.devicePixelRatio || 1));
  let W = 0, H = 0;

  // Mouse parallax suave
  const mouse = { x: 0.5, y: 0.4, tx: 0.5, ty: 0.4 };
  window.addEventListener("mousemove", (e) => {
    mouse.tx = e.clientX / Math.max(1, window.innerWidth);
    mouse.ty = e.clientY / Math.max(1, window.innerHeight);
  }, { passive: true });

  // Colores (coinciden con tu diseño)
  const COLORS = {
    // base claro (como tu web)
    bgTop:   "#f0f4f9",
    bgMid:   "#eaf1fb",
    bgBot:   "#dde8f7",

    // glows con accent
    glowA:   "rgba(59,130,246,0.22)",  // --accent
    glowB:   "rgba(15,31,61,0.10)",    // --navy suave

    // waves (accent + navy)
    wave1:   "rgba(59,130,246,0.18)",
    wave2:   "rgba(15,31,61,0.10)",
    wave3:   "rgba(255,255,255,0.55)",

    // stars
    star:    "rgba(15,31,61,0.55)"
  };

  // Estrellas deterministas
  let stars = [];
  const makeStars = (count) => {
    const rand = mulberry32(987654);
    const arr = new Array(count);
    for (let i = 0; i < count; i++) {
      arr[i] = {
        x: rand(),
        y: rand() * 0.55,
        r: 0.6 + rand() * 1.3,
        a: 0.12 + rand() * 0.55,
        tw: rand() * Math.PI * 2,
        sp: 0.004 + rand() * 0.01
      };
    }
    return arr;
  };

  // Resize
  let resizeQueued = false;
  const resize = () => {
    if (resizeQueued) return;
    resizeQueued = true;

    requestAnimationFrame(() => {
      resizeQueued = false;

      dpr = Math.max(1, Math.min(2, window.devicePixelRatio || 1));
      W = Math.floor(window.innerWidth);
      H = Math.floor(window.innerHeight);

      canvas.width = Math.floor(W * dpr);
      canvas.height = Math.floor(H * dpr);
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);

      const density = clamp((W * H) / 9000, 70, 180);
      stars = makeStars(Math.floor(density));
    });
  };

  window.addEventListener("resize", resize, { passive: true });
  resize();

  // Animación
  let t = 0;
  let last = performance.now();

  function frame(now) {
    const dt = clamp((now - last) / 1000, 0, 0.033);
    last = now;
    t += dt;

    mouse.x += (mouse.tx - mouse.x) * 0.06;
    mouse.y += (mouse.ty - mouse.y) * 0.06;

    draw(t);
    requestAnimationFrame(frame);
  }

  function draw(time) {
    if (!W || !H) return;

    // Base gradient claro
    const g = ctx.createLinearGradient(0, 0, 0, H);
    g.addColorStop(0, COLORS.bgTop);
    g.addColorStop(0.55, COLORS.bgMid);
    g.addColorStop(1, COLORS.bgBot);
    ctx.fillStyle = g;
    ctx.fillRect(0, 0, W, H);

    // Glow suave
    const px = (mouse.x - 0.5) * 60;
    const py = (mouse.y - 0.5) * 40;

    ctx.save();
    ctx.globalCompositeOperation = "multiply";
    ctx.fillStyle = COLORS.glowB;
    ctx.beginPath();
    ctx.ellipse(W * 0.25 + px, H * 0.20 + py, W * 0.28, H * 0.18, 0, 0, Math.PI * 2);
    ctx.fill();
    ctx.restore();

    ctx.save();
    ctx.globalCompositeOperation = "screen";
    ctx.fillStyle = COLORS.glowA;
    ctx.beginPath();
    ctx.ellipse(W * 0.75 - px, H * 0.22 + py, W * 0.30, H * 0.20, 0, 0, Math.PI * 2);
    ctx.fill();
    ctx.restore();

    // Estrellas/puntos (minimalistas)
    ctx.save();
    for (const s of stars) {
      const x = s.x * W;
      const y = s.y * H;
      const tw = 0.5 + 0.5 * Math.sin(time * (2.0 + s.sp * 40) + s.tw);
      const alpha = clamp(s.a * (0.55 + tw * 0.75), 0.04, 0.55);

      ctx.globalAlpha = alpha;
      ctx.fillStyle = COLORS.star;
      ctx.beginPath();
      ctx.arc(x, y, s.r, 0, Math.PI * 2);
      ctx.fill();
    }
    ctx.restore();
    ctx.globalAlpha = 1;

    // Ondas tipo Opulento
    drawWave(time, 0.60, 0.008, 46, 22, COLORS.wave1, 0.0);
    drawWave(time, 0.68, 0.006, 58, 28, COLORS.wave2, 1.1);
    drawWave(time, 0.76, 0.0045, 44, 18, COLORS.wave3, 2.0);

    // Vignette suave para profundidad
    ctx.save();
    ctx.globalCompositeOperation = "multiply";
    const vg = ctx.createRadialGradient(
      W * 0.5, H * 0.45, Math.min(W, H) * 0.25,
      W * 0.5, H * 0.5, Math.max(W, H) * 0.9
    );
    vg.addColorStop(0, "rgba(0,0,0,0)");
    vg.addColorStop(1, "rgba(15,31,61,0.10)");
    ctx.fillStyle = vg;
    ctx.fillRect(0, 0, W, H);
    ctx.restore();
  }

  function drawWave(time, baseYFactor, freq, amp1, amp2, fill, phase) {
    const baseY = H * baseYFactor;
    const speed = 0.9;

    ctx.save();
    ctx.fillStyle = fill;
    ctx.beginPath();
    ctx.moveTo(0, H);
    ctx.lineTo(0, baseY);

    const step = 12;
    const parallax = (mouse.x - 0.5) * 40;

    for (let x = 0; x <= W + step; x += step) {
      const nx = (x + parallax) * freq;
      const y =
        baseY +
        Math.sin(nx + time * speed + phase) * amp1 +
        Math.sin(nx * 0.65 + time * (speed * 1.2) + phase * 1.6) * amp2;

      ctx.lineTo(x, y);
    }

    ctx.lineTo(W, H);
    ctx.closePath();
    ctx.fill();
    ctx.restore();
  }

  function mulberry32(a) {
    return function () {
      let t = (a += 0x6D2B79F5);
      t = Math.imul(t ^ (t >>> 15), t | 1);
      t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
      return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
    };
  }

  // Respeta reduce motion
  const reduceMotion = window.matchMedia &&
    window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  if (!reduceMotion) {
    requestAnimationFrame(frame);
  } else {
    draw(0);
  }
})();