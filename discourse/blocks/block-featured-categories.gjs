import Component from "@glimmer/component";
import { cached } from "@glimmer/tracking";
import { concat } from "@ember/helper";
import { block } from "discourse/blocks";
import getURL from "discourse/lib/get-url";
import Category from "discourse/models/category";
import { i18n } from "discourse-i18n";
import CategoryCard from "../components/category-card.gjs";

/**
 * Displays a grid of featured category cards.
 */
@block("theme:meta:featured-categories", {
  description: "Displays a grid of featured category cards",
  args: {
    categories: { type: "string", default: "" },
    description: { type: "boolean", default: false },
  },
})
export default class BlockFeaturedCategories extends Component {
  @cached
  get featuredCategories() {
    const ids = this.args.categories?.split("|").filter(Boolean) || [];

    return ids.map((id) => Category.findById(Number(id))).filter(Boolean);
  }

  get allCategoriesUrl() {
    return getURL("/categories");
  }

  <template>
    <div class="block-featured-categories__layout">
      {{#each this.featuredCategories as |category|}}
        <CategoryCard
          @category={{category}}
          @href={{category.url}}
          @showDescription={{@description}}
          @description={{category.description_excerpt}}
          @class={{concat
            "block-featured-categories__card"
            (if
              @description " block-featured-categories__card--has-description"
            )
          }}
        />
      {{/each}}
      <div class="block-featured-categories__footer">
        <a
          class="block-featured-categories__all-link"
          href={{this.allCategoriesUrl}}
        >
          {{i18n (themePrefix "homepage.all_categories")}}
        </a>
      </div>
    </div>
  </template>
}
