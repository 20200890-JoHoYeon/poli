document.addEventListener('DOMContentLoaded', function() {
    fetchRandomLetter();

    const gallery = document.querySelector(".gallery");
    let isDown = false;
    let startX;
    let scrollLeft;

    gallery.addEventListener('dragstart', function(e) {
        e.preventDefault();
    });

    gallery.addEventListener("mousedown", (e) => {
        isDown = true;
        gallery.classList.add("active");
        startX = e.pageX - gallery.offsetLeft;
        scrollLeft = gallery.scrollLeft;
    });

    gallery.addEventListener("mouseleave", () => {
        isDown = false;
        gallery.classList.remove("active");
    });

    gallery.addEventListener("mouseup", () => {
        isDown = false;
        gallery.classList.remove("active");
    });

    gallery.addEventListener("mousemove", (e) => {
        if (!isDown) return;
        e.preventDefault();
        const x = e.pageX - gallery.offsetLeft;
        const walk = (x - startX) * 1.5;
        gallery.scrollLeft = scrollLeft - walk;
    });
});

document.addEventListener('click', (event) => {
    const centerImage = document.getElementById('centerImage');
    const overlay = centerImage.querySelector('.overlay');
    const clickedInsideCenterImage = event.target.closest('#centerImage');
    const clickedOverlay = event.target.closest('.overlay');

    if (clickedInsideCenterImage && !clickedOverlay) {
        centerImage.querySelector('img').style.filter = 'brightness(0.5)';
        overlay.classList.add('visible');
    } else if (!clickedInsideCenterImage) {
        centerImage.querySelector('img').style.filter = 'none';
        overlay.classList.remove('visible');
    }
});

function fetchRandomLetter() {
    const xhr = new XMLHttpRequest();
    xhr.open('GET', 'getRandomLetter.jsp', true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState == 4 && xhr.status == 200) {
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = xhr.responseText;

            const songName = tempDiv.querySelector('#song_name').textContent;
            const url = tempDiv.querySelector('#url').textContent;
            const lifeQuotes = tempDiv.querySelector('#lifeQuotes').innerHTML;

            updateSlide(songName, url, lifeQuotes);
        }
    };
    xhr.send();
}

function updateSlide(songName, url, lifeQuotes) {
    const overlayTitle = document.getElementById('overlay-title').querySelector('a');
    const overlayText = document.getElementById('overlay-text');

    overlayTitle.textContent = songName;
    overlayTitle.href = url;
    overlayText.innerHTML = lifeQuotes;
}

function changeSlide(direction) {
    fetchRandomLetter();
    let currentSlide = 0;
    const slidesContainer = document.querySelector('.slides');
    const slides = slidesContainer.children;
    slidesContainer.style.transition = 'transform 0.5s ease';
    slidesContainer.style.transform = `translateX(${direction * -100 / slides.length}%)`;

    setTimeout(() => {
        currentSlide = (currentSlide + direction + slides.length) % slides.length;
        slidesContainer.style.transition = 'none';
        slidesContainer.style.transform = 'translateX(0)';
    }, 500);
}

document.getElementById("gradeButton").addEventListener("click", function() {
    alert("브론즈: 기본 등급\n실버: 글 5개 + 탄생일 D+5일\n골드: 글 15개 + 탄생일 D+15일\n다이아: 글 25개 + 탄생일 D+25일");
});

function logout() {
    fetch('logout.jsp')
        .then(() => window.location.href = 'login.jsp');
}