static const char norm_fg[] = "#C8CACC";
static const char norm_bg[] = "#3D3D3D";
static const char norm_border[] = "#4D4D4D";

static const char sel_fg[] = "#C8CACC";
static const char sel_bg[] = "#6673BF";
static const char sel_border[] = "#C8CACC";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
};
