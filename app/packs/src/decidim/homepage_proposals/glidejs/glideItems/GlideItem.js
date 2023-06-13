export default class GlideItem {
    constructor(url) {
        this.url = url;
    }

    placeholder() {
        return `<div class="column glide__slide"></div>`
    }

    bullet(idx) {
        return `<div class="glide__bullet glide__bullet_idx" data-glide-dir="=${idx}">
  <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" class="bi bi-circle-fill" viewBox="0 0 16 16">
    <circle cx="7" cy="7" r="7"/>
  </svg>
</div>`
    }
}
