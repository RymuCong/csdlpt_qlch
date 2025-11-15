<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tuyết bay không trọng lực</title>
    <style>
        body {
            margin: 0;
            background-color: none;
            overflow-x: hidden;
        }
        canvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 9999;
        }
    </style>
</head>
<body>
    <canvas id="snowCanvas"></canvas>
    <script>
        const canvas = document.getElementById("snowCanvas");
        const ctx = canvas.getContext("2d");

        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;

        const numFlakes = 20; 
        const flakes = [];
        const explosions = [];
        const snowflakeImg = new Image();
        snowflakeImg.src = "/images/head.png"; 

        const rainbowColors = ["red", "orange", "yellow", "green", "blue", "indigo", "violet"];

        class Snowflake {
            constructor() {
                this.reset();
            }
            reset() {
                this.x = Math.random() * canvas.width;
                this.y = Math.random() * canvas.height;
                this.size = Math.random() * 50 + 30;
                this.speedX = (Math.random() - 0.5) * 2;
                this.speedY = (Math.random() - 0.5) * 2;
                this.angle = Math.random() * Math.PI * 2;
                this.spin = (Math.random() - 0.5) * 0.05;
            }
            update() {
                this.x += this.speedX;
                this.y += this.speedY;
                this.angle += this.spin;
                if (this.x < 0 || this.x > canvas.width || this.y < 0 || this.y > canvas.height) {
                    this.reset();
                }
            }
            draw() {
                ctx.save();
                ctx.translate(this.x, this.y);
                ctx.rotate(this.angle);
                ctx.drawImage(snowflakeImg, -this.size / 2, -this.size / 2, this.size, this.size);
                ctx.restore();
            }
        }

        class Particle {
            constructor(x, y) {
                this.x = x;
                this.y = y;
                this.size = Math.random() * 50 + 30;
                this.speedX = (Math.random() - 0.5) * 20; // Bay xa hơn
                this.speedY = (Math.random() - 0.5) * 20; 
                this.life = 60; // Tồn tại lâu hơn
                this.color = rainbowColors[Math.floor(Math.random() * rainbowColors.length)];
            }
            update() {
                this.x += this.speedX;
                this.y += this.speedY;
                this.life--;
            }
            draw() {
                ctx.fillStyle = this.color;
                ctx.globalAlpha = this.life / 60; // Mờ dần theo thời gian
                ctx.beginPath();
                ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
                ctx.fill();
                ctx.globalAlpha = 1;
            }
        }

        for (let i = 0; i < numFlakes; i++) {
            flakes.push(new Snowflake());
        }

        function animate() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            flakes.forEach(flake => {
                flake.update();
                flake.draw();
            });

            explosions.forEach((exp, index) => {
                exp.particles.forEach(particle => {
                    particle.update();
                    particle.draw();
                });
                exp.particles = exp.particles.filter(p => p.life > 0);
                if (exp.particles.length === 0) {
                    explosions.splice(index, 1);
                }
            });

            requestAnimationFrame(animate);
        }

        canvas.addEventListener("click", (event) => {
            for (let i = flakes.length - 1; i >= 0; i--) {
                let flake = flakes[i];
                let dx = event.clientX - flake.x;
                let dy = event.clientY - flake.y;
                let distance = Math.sqrt(dx * dx + dy * dy);

                if (distance < flake.size / 2) {
                    let explosion = { particles: [] };
                    for (let j = 0; j < 70; j++) { // Số hạt nổ tăng lên 70
                        explosion.particles.push(new Particle(flake.x, flake.y));
                    }
                    explosions.push(explosion);
                    flakes.splice(i, 1);
                    break;
                }
            }
        });

        snowflakeImg.onload = () => {
            animate();
        };

        window.addEventListener("resize", () => {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
        });
    </script>
</body>
</html>