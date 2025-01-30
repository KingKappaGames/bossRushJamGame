draw_set_alpha(random_range(effectAlpha * (1 - effectAgePercent), (1 - effectAgePercent)));
draw_rectangle_color(x - beamWidth, y + 3, x + beamWidth, y - 600, effectColor, effectColor, effectColor, effectColor, false);
draw_ellipse_color(x - beamWidth * 1.05, y - 8, x + beamWidth * 1.05, y + 8, effectColor, effectColor, false);
draw_ellipse_color(x - beamWidth * 1.45, y - 15, x + beamWidth * 1.45, y + 15, effectColor, effectColor, false);
draw_set_alpha(1);