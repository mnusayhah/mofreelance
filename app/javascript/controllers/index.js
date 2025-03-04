import { application } from "controllers/application";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";

// Automatically load all controllers
eagerLoadControllersFrom("controllers", application);
