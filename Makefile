DEPLOYFILES=Dockerfile apache2.sh
VERSION = ` grep Version Dockerfile | cut -d " " -f 3 `
ZIPNAME = dkr-ms_$(VERSION).zip

all: zip

zip: $(DEPLOYFILES)
	echo "Packaging for AWS - Version " $(VERSION)
	@zip $(ZIPNAME) $(DEPLOYFILES)

clean:
	@rm $(ZIPNAME)
