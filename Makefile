all: build/linux.zip build/macos.zip build/win.zip

GODOT_BIN ?= godot
GODOT_TEMPLATE_LOCATION ?= ls ~/.local/share/godot/export_templates/4.2.stable_mono/

clean:
	rm -r build || true
	rm -r gfx/licensed || true
	rm -r target || true
	rm -r node_modules || true
	rm -rf godot || true
	rm -rf gdexport || true

build/base: gfx/licensed/.cookie $(glob addons/*/LICENSE) ATTRIBUTION
	mkdir -p build/base
	cp ATTRIBUTION build/base/ATTRIBUTION

build/base.zip: build/base
	zip build/base.zip build/base/*

gfx/licensed/.cookie: .secret.env
	./licensed_setup.sh
	rm -r gfx/licensed/modern/Ext/Modern_Exteriors_{32x32,48x48} `find gfx/licensed/modern/Int -name 32x32 -or -name 48x48`
	touch gfx/licensed/.cookie

build/linux.zip: build/base.zip build/linux.cookie
	cp build/base.zip build/linux.zip
	zip -9r build/linux.zip build/linux/*

build/linux.cookie: project.godot
	mkdir -p build/linux
	echo "godot --headless --export-release Linux build/linux/Nightshade.x86_64" | ./godot-ci-wrap.sh
	touch build/linux.cookie
