import { setCookie, readCookie } from "helpers/cookie_helpers"

export function getReadingProgress(blogId) {
  const progress = readCookie(`reading_progress_${blogId}`)

  if (progress) {
    const [ leafId, lastReadParagraph ] = progress.split("/")
    return [ parseInt(leafId), parseInt(lastReadParagraph) || 0 ]
  } else {
    return [ undefined, 0 ]
  }
}

export function storeReadingProgress(blogId, leafId, lastReadParagraphIndex) {
  setCookie(`reading_progress_${blogId}`, `${leafId}/${lastReadParagraphIndex}`)
}
