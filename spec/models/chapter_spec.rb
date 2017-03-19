require 'rails_helper'

describe Chapter do
  let(:book) { create_markdown_book! }

  context "navigation" do
    context "chapter 1" do
      let(:chapter) do
        book.chapters.find_or_create_by(
          file_name: "chapter_1/chapter_1.markdown",
          position: 1,
          part: "mainmatter"
        )
      end

      it "links back to only chapter in previous part" do
        introduction = book.chapters.create(
          title: "Introduction",
          position: 1,
          part: "frontmatter"
        )

        expect(chapter.previous_chapter).to eq(introduction)
      end

      it "links back to highest positioned chapter in previous part" do
        introduction = book.chapters.create(
          title: "Introduction",
          position: 1,
          part: "frontmatter"
        )

        foreword = book.chapters.create(
          title: "Introduction",
          position: 2,
          part: "frontmatter"
        )

        expect(chapter.previous_chapter).to eq(foreword)
      end


      it "links to next chapter in same part" do
        chapter_2 = book.chapters.create(
          title: "Chapter 2",
          position: 2,
          part: "mainmatter"
        )

        expect(chapter.next_chapter).to eq(chapter_2)
      end
    end

    context "last chapter of part" do
      let!(:chapter_1) do
        book.chapters.find_or_create_by(
          file_name: "chapter_1/chapter_1.markdown",
          position: 1,
          part: "mainmatter"
        )
      end

      let!(:chapter_2) do
        book.chapters.find_or_create_by(
          file_name: "chapter_2/chapter_2.markdown",
          position: 2,
          part: "mainmatter"
        )
      end

      it "links back to previous chapter" do
        expect(chapter_2.previous_chapter).to eq(chapter_1)
      end

      it "links to first chapter in next part" do
        appendix_a = book.chapters.create(
          title: "Appendix A",
          position: 1,
          part: "backmatter"
        )

        appendix_b = book.chapters.create(
          title: "Appendix B",
          position: 2,
          part: "backmatter"
        )

        expect(chapter_2.next_chapter).to eq(appendix_a)
      end
    end
  end

  context "part_position" do
    let!(:preface) do
      book.chapters.create(
        title: "Preface",
        position: 3,
        part: "frontmatter"
      )
    end

    let!(:chapter_1) do
      book.chapters.create(
        title: "First Chapter",
        position: 2,
        part: "mainmatter",
      )
    end

    let!(:chapter_2) do
      book.chapters.create(
        title: "Second Chapter",
        position: 3,
        part: "mainmatter",
      )
    end

    it "returns position relative to the part of the book" do
      expect(preface.part_position).to eq(1)
      expect(chapter_1.part_position).to eq(1)
      expect(chapter_2.part_position).to eq(2)
    end
  end
end
