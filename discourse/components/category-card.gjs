import Component from "@glimmer/component";
import { service } from "@ember/service";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import BasicTopicList from "discourse/components/basic-topic-list";
import DButton from "discourse/components/d-button";
import { bind } from "discourse/lib/decorators";
import Category from "discourse/models/category";
import { i18n } from "discourse-i18n";

@block("theme:meta:featured-list", {
  description: "Displays a list of topics with various filtering options",
  args: {
    count: { type: "number", default: 5 },
    title: { type: "string" },
    linkLabel: { type: "string" },
    linkHref: { type: "string" },
    filter: { type: "string", default: "latest" },
    categoryId: { type: "number" },
    tag: { type: "string" },
    solved: { type: "boolean" },
  },
})
export default class BlockFeaturedList extends Component {
  @service store;
  @service currentUser;

  /**
   * Builds the filter path for the topic list API.
   * @param {string} filterType - The filter type (latest, top, new, etc.)
   * @param {number} [categoryId] - Optional category ID
   * @param {string} [tag] - Optional tag name
   * @returns {string} The filter path
   */
  #buildFilterPath(filterType, categoryId, tag) {
    if (categoryId && tag) {
      const category = Category.findById(categoryId);
      if (category) {
        return `tags/c/${Category.slugFor(category)}/${category.id}/${tag}/l/${filterType}`;
      }
    }

    if (categoryId) {
      const category = Category.findById(categoryId);
      if (category) {
        return `c/${Category.slugFor(category)}/${category.id}/l/${filterType}`;
      }
    }

    if (tag) {
      return `tag/${tag}/l/${filterType}`;
    }

    return filterType;
  }

  @bind
  async fetchTopics() {
    const count = this.args.count || 5;
    const filterType = this.args.filter || "latest";
    const categoryId = this.args.categoryId;
    const tag = this.args.tag;
    const solved = this.args.solved;

    // User-specific filters require authentication
    const userFilters = ["new", "unread"];
    if (userFilters.includes(filterType) && !this.currentUser) {
      return null;
    }

    const filter = this.#buildFilterPath(filterType, categoryId, tag);
    const params = solved ? { solved } : {};

    const topicList = await this.store.findFiltered("topicList", {
      filter,
      params,
    });

    if (!topicList.topics?.length) {
      return null;
    }

    return topicList.topics.slice(0, count);
  }

  <template>
    <div class="block-featured-list__layout">
      {{#if @title}}
        <div class="block-featured-list__header">
          <h2 class="block-featured-list__title">
            {{i18n (themePrefix @title)}}
          </h2>
          {{#if @linkHref}}
            <DButton
              class="btn btn-primary block-featured-list__link"
              @href={{@linkHref}}
              @translatedLabel={{i18n (themePrefix @linkLabel)}}
            />
          {{/if}}
        </div>
      {{/if}}

      <AsyncContent @asyncData={{this.fetchTopics}}>
        <:loading>
          <div class="block-featured-list__loading">
            <div class="spinner"></div>
          </div>
        </:loading>

        <:empty>
          <div class="block-featured-list__empty">
            {{i18n "topics.none.latest"}}
          </div>
        </:empty>

        <:content as |topics|>
          <div class="block-featured-list__topic-list">
            <BasicTopicList @topics={{topics}} @showPosters="true" />

            {{#if @linkHref}}
              <div class="block-featured-list__footer">
                <a class="block-featured-list__all-link" href={{@linkHref}}>
                  {{i18n (themePrefix @linkLabel)}}
                </a>
              </div>
            {{/if}}
          </div>
        </:content>
      </AsyncContent>
    </div>
  </template>
}
