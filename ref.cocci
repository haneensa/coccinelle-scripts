@r1@
expression e;
@@

(
-drm_gem_object_reference(e);
+drm_gem_object_get(e);
|
-drm_gem_object_unreference(e);
+drm_gem_object_put(e);
|
-drm_gem_object_unreference_unlocked(e);
+drm_gem_object_put_unlocked(e);
)

