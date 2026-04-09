import { apiInitializer } from "discourse/lib/api";
import BlockCategoryBanner from "../blocks/block-category-banner.gjs";

export default apiInitializer((api) => {
  api.renderBlocks("main-outlet-blocks", [
    {
      block: BlockCategoryBanner,
      args: { showDescription: true, showIcon: false },
      conditions: {
        type: "route",
        pages: ["CATEGORY_PAGES"],
      },
    },
  ]);
});
