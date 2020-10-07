fn main() {
    cc::Build::new()
        .file("src/function.S")
        .compile("corooteen-helper");
}
