import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { block } from "discourse/blocks";
import DButton from "discourse/components/d-button";
import cookie from "discourse/lib/cookie";
import getURL from "discourse/lib/get-url";
import { i18n } from "discourse-i18n";

/**
 * Displays a dismissable banner with custom content.
 *
 * @component BlockCTABanner
 * @param {string} [title] - Locale key for banner header text
 * @param {string} [content] - Locale key for banner content text
 * @param {string} [linkLabel] - Locale key for CTA button label
 * @param {string} [linkHref] - Locale key for CTA button href
 * @param {boolean} [dismissable] - Whether the banner can be dismissed
 */
@block("theme:meta:cta-banner", {
  description: "Displays a dismissable banner with custom content",
  args: {
    title: { type: "string" },
    content: { type: "string" },
    linkLabel: { type: "string" },
    linkHref: { type: "string" },
    dismissable: { type: "boolean", default: false },
  },
})
export default class BlockCTABanner extends Component {
  @service currentUser;
  @service router;

  @tracked dismissed = document.cookie.includes(
    "discourse-dismissable-banner=dismissed"
  );

  get shouldShow() {
    const routeName = this.router.currentRouteName;
    const isAdminRoute = routeName.includes("admin");
    const isChatRoute = routeName.includes("chat");

    const isDismissed = this.args.dismissable && this.dismissed;

    return (
      !isDismissed &&
      !isAdminRoute &&
      !isChatRoute &&
      !(settings.hide_for_logged_in_users && this.currentUser)
    );
  }

  get hasActions() {
    return !!(this.args.linkHref || this.args.dismissable);
  }

  @action
  dismissBanner() {
    const now = new Date();
    now.setMonth(now.getMonth() + 3);

    const cookiePath = getURL("/");

    cookie("discourse-dismissable-banner", "dismissed", {
      path: cookiePath,
      secure: true,
      expires: now,
    });

    this.dismissed = true;
  }

  <template>
    {{#if this.shouldShow}}

      <div class="block-cta-banner__layout">
        <div class="block-cta-banner__content">
          <h3 class="block-cta-banner__title">
            {{i18n (themePrefix @title)}}
          </h3>

          <p class="block-cta-banner__text">
            {{i18n (themePrefix @content)}}
          </p>
        </div>

        {{#if this.hasActions}}
          <div class="block-cta-banner__actions">
            {{#if @linkHref}}
              <DButton
                class="btn btn-primary"
                @href={{i18n (themePrefix @linkHref)}}
                @translatedLabel={{i18n (themePrefix @linkLabel)}}
              />
            {{/if}}
            {{#if @dismissable}}
              <DButton
                @icon="xmark"
                @action={{this.dismissBanner}}
                class="block-cta-banner__close"
              />
            {{/if}}
          </div>
        {{/if}}
      </div>

    {{/if}}
  </template>
}
