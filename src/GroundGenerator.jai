texture: Texture;
image: Image;

main :: () {
    koda_init();

    create_window("Ground Generator", 1920, 1080);
    set_vsync(true);

    texture = load_texture("assets/ground-1.png");

    start_time := get_time();
    while !should_exit() {
        clear(.{1.0, 1.0, 1.0, 1.0});

        if get_time() - start_time > 1 {
            update_texture();
        }

        draw(texture, .{});
    }
}

update_texture :: () {
    // TODO probably destroy image here, right?
    image = create_image(texture);
    draw_rectangle(*image, Point2.{400, 400}, Point2.{100, 100}, .{1.0, 0.0, 0.0, 1.0});
    // TODO probably destroy texture here, right?
    texture = create_texture(image);
}

#import "JaiMath";
#import "KodaJai";
#import "Basic";