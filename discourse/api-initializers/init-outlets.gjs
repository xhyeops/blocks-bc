import { apiInitializer } from "discourse/lib/api";
import MetaBg from "../components/meta-bg.gjs";

export default apiInitializer((api) => {
  api.renderInOutlet("above-site-header", MetaBg);
});
