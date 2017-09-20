@r1@
expression e;
@@

(
-drm_framebuffer_reference(e);
+drm_framebuffer_get(e);
|
-drm_framebuffer_unreference(e);
+drm_framebuffer_put(e);
)

