import GlideItem from "./GlideItem";

export default class Proposal extends GlideItem {
    constructor(obj) {
        super();
        this.title = obj.title;
        this.body = obj.body;
        this.image = obj.image;
        this.url = obj.url;
    }

    render() {
        return `<div class="column glide__slide">
<div class="card card--proposal card--stack">
    <a href="${this.url}">
      <div class="proposal-glance card--header">
      <img src="${this.image}" class="proposal-glance__img" alt="slider_img">
</div>
    </a>

    <div class="card--process__small text-center padding-1">
        <a href="${this.url}"><h3 class="proposal-glance card__title">${this.title}</h3></a>
        <div class="card__text--paragraph padding-top-1">
            <p>${this.body}</p>
        </div>
        <a href="${this.url}">
            <div class="card__button align-bottom padding-top-1">
                <span class="button small button--secondary">Visit</span>
            </div>
        </a>
    </div>
  </div>
</div>`
    }

}