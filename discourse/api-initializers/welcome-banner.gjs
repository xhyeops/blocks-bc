import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  api.registerValueTransformer(
    "welcome-banner-display-for-route",
    ({ context }) => {
      const { currentRouteName } = context;

      return currentRouteName === "discovery.custom";
    }
  );
});
