package epubWriter;

import rl "vendor:raylib";
import "core:fmt";
import "core:strings";
import "core:strconv";
book :: struct {
	name: string,
	author: string,
	cover: rl.Texture2D,
	chapters: [dynamic]chapter,
	outputPath: string
}

chapter :: struct {
	name: string,
	id: int,
	pages: [dynamic]page,
	_pathInEpub: string
}

page :: struct {
	loc: int,
	text: string
}


writeEpub :: proc(theBook: book) {
	chapters := make([dynamic]string)
	
	for theChapter in theBook.chapters {
		sb: strings.Builder;
		strings.builder_init(&sb);
		defer strings.builder_destroy(&sb);
		itoaBuf: [1024]byte; // do not blame me this breaks since your book is most likely not small enough to fit in a terabyte
		chapterNumStr := strconv.write_int(itoaBuf[:], i64(theChapter.id), 10)
		strings.write_string(&sb, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
		strings.write_string(&sb, "<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"en\" xml:lang=\"en\">\n");
		strings.write_string(&sb, "<head>\n");
		strings.write_string(&sb, "<title>");
		strings.write_string(&sb, "Chapter ");
		strings.write_string(&sb, chapterNumStr);
		strings.write_string(&sb, "</title>\n");
		strings.write_string(&sb, "</head>\n");

		strings.write_string(&sb, "<body>\n");
		strings.write_string(&sb, "<section>\n");
		strings.write_string(&sb, "<h1 id=\"chapter");
		strings.write_string(&sb, chapterNumStr);
		strings.write_string(&sb, "\">");
		strings.write_string(&sb, theChapter.name);
		strings.write_string(&sb, "</h1>\n");
		for thePage in theChapter.pages {
			strings.write_string(&sb, thePage.text);
			strings.write_string(&sb, "\nPage ");
			strings.write_string(&sb, strconv.write_int(itoaBuf[:], i64(thePage.loc), 10));
		}
		strings.write_string(&sb, "\n</section>\n");
		strings.write_string(&sb, "</body>\n");
		strings.write_string(&sb, "</html>\n");
		append(&chapters, strings.to_string(sb));
	}
	
	
}

main :: proc () { // here for testing will not be in the final library
	
	aPage := page{
		loc = 1,
		text = "Hello, World!"
	}

	pages := make([dynamic]page)
	defer delete(pages)
	append(&pages, aPage)
	
	aChapter := chapter{
		id = 1,
		name = "printf(\"Hello, World!\");",
		pages = pages
	}

	chapters := make([dynamic]chapter)
	defer delete(chapters)
	append(&chapters, aChapter)
	
	aBook := book{
		name = "testing",
		author = "anonymous",
		cover = rl.Texture2D{},
		chapters = chapters,
		outputPath = "tests/out.epub"
	}

	writeEpub(aBook);
}
