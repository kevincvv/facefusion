LOG-LEVEL := "debug"
FACE-OCCLUDER-MODEL := "many"
FACE-SWAPPER-MODEL := "inswapper_128_fp16"
FACE-SWAPPER-PIXEL-BOOST := "1024x1024"
FACE-ENHANCER-WEIGHT := "0.7"

# CHANGE ME!!
SOURCE := 'SOURCE_PATH/*.jpg'
TARGET := 'TARGET_PATH/*.jpg'
OUTPUT := 'OUTPUT_PATH/ff-{target_name}.{target_extension}'

[doc('List available recipes')]
[group('justfile')]
default:
    @just -f {{ justfile() }} --list

[doc('Activate venv')]
[group('ff')]
activate:
	@conda activate facefusion

[doc('Serve WebUI')]
[group('ff')]
serve:
	@python facefusion.py run --execution-thread-count 2 --system-memory-limit 4

[doc('Batch swap')]
[group('ff')]
batch:
    @python facefusion.py batch-run \
    	--log-level {{ LOG-LEVEL }} \
    	--face-occluder-model {{ FACE-OCCLUDER-MODEL }} \
    	--face-swapper-model {{ FACE-SWAPPER-MODEL }} \
    	--face-swapper-pixel-boost {{ FACE-SWAPPER-PIXEL-BOOST }} \
    	--face-enhancer-weight {{ FACE-ENHANCER-WEIGHT }} \
    	--source-pattern "{{ SOURCE }}" \
    	--target-pattern "{{ TARGET }}" \
    	--output-pattern "{{ OUTPUT }}"


[doc('Build for linux/amd64')]
[group('docker')]
build:
	@docker build --platform linux/amd64 -t facefusion-tensorrt-runpod -f Dockerfile.tensorrt .
