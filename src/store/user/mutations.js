export const updateUid = (state, uid) => {
  state.uid = uid
}
export const updateAvatar = (state, avatarUrl) => {
  state.avatarUrl = avatarUrl
}
export const updateMsgCount = (state, unreadMsgCount) => {
  state.unreadMsgCount = unreadMsgCount
}
export default function () {
  return {
    uid: true,
    avatarUrl: true,
    name: null,
    organizations: [],
    location: null,
    unreadMsgCount: null
  }
}
