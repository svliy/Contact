import request from "@/utils/request";

class contactApi {
  // 登录
  login(date) {
    return request.post("/user/login", date, {
      headers: { 'Content-Type': "application/json;charset=utf-8" },
    });
  }

  getUserByUserName(date) {
    return request.get("/user/username/" + date, {
      headers: { 'Content-Type': "application/json;charset=utf-8" },
    });
  }

  getUserPage(date) {
    return request.get("/user/page", {
      params: date.params,
      headers: { 'Content-Type': "application/json;charset=utf-8" },
    })
  }

  getFeebBackPage(date) {
    return request.get("/user/pageFeebBack", {
      params: date.params,
      headers: { 'Content-Type': "application/json;charset=utf-8" },
    })
  }

  addUser(date) {
    return request.post("/user/addUser", date, {
      headers: { 'Content-Type': "application/json;charset=utf-8" },
    })
  }

  deleteUserById(date) {
    return request.post("/user/deleteUser/" + date,"", {
      headers: { 'Content-Type': "application/json;charset=utf-8" },
    })
  }

  selectFeedBackById(date) {
    return request.post("/user/selectFb/" + date,"", {
      headers: { 'Content-Type': "application/json;charset=utf-8" },
    })
  }


  deleteUserBatchById(date) {
    return request.post("/user/del/batch", date, {
      headers: { 'Content-Type': "application/json;charset=utf-8" },
    })
  }

  openDomain(data){
    return request.post("/user/opendomain/" + data,"",{
      headers: {
        'Content-Type': "application/json;charset=utf-8"
      }
    })
  }
  closedDomain(data){
    return request.post("/user/closeddomain/" + data,"",{
      headers: {
        'Content-Type': "application/json;charset=utf-8"
      }
    })
  }
  addFeedBack(date) {
    return request.post("/user/addfeedback", date, {
      headers: { 'Content-Type': "application/json;charset=utf-8" },
    })
  }

  getFeedBackList(date) {
    return request.get("/user/getFeedBackList/" + date, {
      headers: { 'Content-Type': "application/json;charset=utf-8" },
    });
  }

  getAllDataForTJ(date) {
    return request.get("/getAllDataForTJ", {
      headers: { 'Content-Type': "application/json;charset=utf-8" },
    });
  }

  getAllDataByList(data) {
    return request.post("/getAllDataByList", data,{
      headers: { 'Content-Type': "application/json;charset=utf-8" },
    });
  }

  register(date) {
    return request.post("/user/register", date, {
      headers: { 'Content-Type': "application/json;charset=utf-8" },
    })
  }
}

export default new contactApi();
