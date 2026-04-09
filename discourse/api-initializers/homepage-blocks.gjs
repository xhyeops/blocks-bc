import { apiInitializer } from "discourse/lib/api";
import BlockCTABanner from "../blocks/block-cta-banner";
import BlockFeaturedCategories from "../blocks/block-featured-categories";
import FeaturedList from "../blocks/block-featured-list";

export default apiInitializer((api) => {
  api.renderBlocks("homepage-blocks", [
    {
      block: BlockFeaturedCategories,
      args: {
        categories: settings.homepage_categories,
      },
    },

    {
      block: FeaturedList,
      id: "latest-topics",
      args: {
        title: "homepage.list",
        count: 12,
        linkLabel: "homepage.link",
        linkHref: "/latest",
      },
    },
    {
      block: BlockCTABanner,
      args: {
        title: "cta-banner.title",
        content: "cta-banner.content",
        linkLabel: "cta-banner.link_label",
        linkHref: "cta-banner.link_href",
      },
    },
  ]);
});
