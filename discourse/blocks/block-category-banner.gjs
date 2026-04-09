import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat } from "@ember/helper";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import didUpdate from "@ember/render-modifiers/modifiers/did-update";
import { service } from "@ember/service";
import { trustHTML } from "@ember/template";
import { block } from "discourse/blocks";
import CategoryLogo from "discourse/components/category-logo";
import bodyClass from "discourse/helpers/body-class";
import { categoryLinkHTML } from "discourse/helpers/category-link";
import concatClass from "discourse/helpers/concat-class";
import icon from "discourse/helpers/d-icon";
import Category from "discourse/models/category";
import CategoryCard from "../components/category-card.gjs";

/**
 * Displays a category banner with logo, title, and description.
 *
 * @component BlockCategoryBanner
 * @param {boolean} [showDescription] - Show category description
 * @param {boolean} [showIcon] - Show category icon or emoji
 * @param {boolean} [showLogo] - Show category logo
 */
@block("theme:meta:category-banner", {
  description: "Displays a category banner with logo, title, and description",
  args: {
    showDescription: { type: "boolean" },
    showIcon: { type: "boolean" },
    showLogo: { type: "boolean" },
  },
})
export default class BlockCategoryBanner extends Component {
  @service router;

  @tracked category = null;
  @tracked keepInLoadingRoute = false;

  get categorySlugPathWithID() {
    return this.router?.currentRoute?.params?.category_slug_path_with_id;
  }

  get shouldRender() {
    return (
      this.categorySlugPathWithID ||
      (this.keepInLoadingRoute &&
        this.router.currentRoute.name.includes("loading"))
    );
  }

  get isVisible() {
    if (this.categorySlugPathWithID) {
      return true;
    } else if (this.router.currentRoute.name.includes("loading")) {
      return this.keepInLoadingRoute;
    }
    return false;
  }

  get safeStyle() {
    return trustHTML(
      `--category-banner-background: #${this.category.color}; --category-banner-color: #${this.category.text_color};`
    );
  }

  get displayCategoryDescription() {
    return this.args.showDescription && this.category.description?.length > 0;
  }

  get showCategoryIcon() {
    const hasIcon = this.category.style_type === "icon" && this.category.icon;
    const hasEmoji =
      this.category.style_type === "emoji" && this.category.emoji;

    if (this.args.showIcon && (hasIcon || hasEmoji)) {
      return true;
    } else {
      return false;
    }
  }

  get categoryNameBadge() {
    return categoryLinkHTML(this.category, {
      allowUncategorized: true,
      link: false,
    });
  }

  get hasSubcategories() {
    return this.category?.subcategories?.length > 0;
  }

  @action
  getCategory() {
    if (!this.isVisible) {
      return;
    }

    if (this.categorySlugPathWithID) {
      this.category = Category.findBySlugPathWithID(
        this.categorySlugPathWithID
      );

      this.keepInLoadingRoute = true;
    } else {
      if (!this.router.currentRoute.name.includes("loading")) {
        return (this.keepInLoadingRoute = false);
      }
    }
  }

  <template>
    {{#if this.shouldRender}}
      {{bodyClass "block-category-banner"}}

      <div
        {{didInsert this.getCategory}}
        {{didUpdate this.getCategory this.isVisible}}
        class={{concatClass
          "block-category-banner__layout"
          (if this.category (concat this.category.slug))
        }}
        style={{if this.category this.safeStyle}}
      >
        {{#if this.category}}
          <div class="block-category-banner__content">

            {{#if @showLogo}}
              <CategoryLogo
                class="block-category-banner__logo"
                @category={{this.category}}
              />
            {{/if}}

            <h2 class="block-category-banner__title">
              {{#if this.showCategoryIcon}}
                {{this.categoryNameBadge}}
              {{else}}
                {{#if this.category.read_restricted}}
                  {{icon "lock"}}
                {{/if}}
                {{this.category.name}}
              {{/if}}
            </h2>

            {{#if this.displayCategoryDescription}}
              <div class="block-category-banner__description">
                <div class="cooked">
                  {{trustHTML this.category.description}}
                </div>
              </div>
            {{/if}}

            {{#if this.hasSubcategories}}
              <ul
                class="block-category-banner__subcategories"
                aria-label="Subcategories"
              >
                {{#each this.category.subcategories as |subcategory|}}
                  <li class="block-category-banner__subcategory">
                    <CategoryCard
                      @category={{subcategory}}
                      @href={{subcategory.url}}
                      @class="block-category-banner__subcategory-card"
                    />
                  </li>
                {{/each}}
              </ul>
            {{/if}}

          </div>
        {{/if}}
      </div>
    {{/if}}
  </template>
}
