<template>
  <div>
    <div style="margin: 10px 0">
      <el-input
        style="width: 200px"
        placeholder="请输入id"
        suffix-icon="el-icon-search"
        v-model="id"
      ></el-input>
      <el-input
        style="width: 200px"
        placeholder="请输入图谱Id"
        suffix-icon="el-icon-message"
        class="ml-5"
        v-model="domain_id"
      ></el-input>
      <el-button class="ml-5" type="primary" @click="load">搜索</el-button>
      <el-button type="warning" @click="reset">重置</el-button>
    </div>

    <div style="margin: 10px 0">
      <el-button type="primary" @click="handleAdd">
        新增 <i class="el-icon-circle-plus-outline"></i>
      </el-button>
      <el-popconfirm
        class="ml-5"
        confirm-button-text="确定"
        cancel-button-text="我再想想"
        icon="el-icon-info"
        icon-color="red"
        title="您确定批量删除这些数据吗？"
        @confirm="delBatch"
      >
        <el-button type="danger" slot="reference"
        >批量删除 <i class="el-icon-remove-outline"></i
        ></el-button>
      </el-popconfirm>
      <!--      <el-button type="primary" class="ml-5"-->
      <!--      >导入 <i class="el-icon-bottom"></i-->
      <!--      ></el-button>-->
      <!--      <el-button type="primary">导出 <i class="el-icon-top"></i></el-button>-->
    </div>

    <el-table
      :data="tableData"
      border
      stripe
      :header-cell-class-name="'headerBg'"
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55"></el-table-column>
      <el-table-column prop="id" label="ID" width="80"></el-table-column>
      <el-table-column
        prop="domainId"
        label="图谱Id"
        width="140"
      ></el-table-column>
      <el-table-column
        prop="userId"
        label="用户Id"
        width="120"
      ></el-table-column>
      <el-table-column prop="content" label="内容"></el-table-column>
      <el-table-column prop="createTime" label="反馈时间"></el-table-column>
      <el-table-column prop="isActive" label="是否精选"></el-table-column>
      <el-table-column label="操作" width="200" align="center">
        <template slot-scope="scope">
<!--          <el-button type="success" @click="handleEdit(scope.row)">-->
<!--            编辑 <i class="el-icon-edit"></i>-->
<!--          </el-button>-->
<!--          <el-button type="success" @click="handleEdit(scope.row)">-->
<!--            精选 <i class="el-icon-edit"></i>-->
<!--          </el-button>-->
          <el-popconfirm
            class="ml-5"
            confirm-button-text="确定"
            cancel-button-text="我再想想"
            icon="el-icon-info"
            icon-color="green"
            title="您确定精选该内容吗？"
            @confirm="del(scope.row.id)"
          >
            <el-button type="success" slot="reference">
              精选<i class="el-icon-remove-outline"></i>
            </el-button>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
    <div style="padding: 10px 0">
      <el-pagination
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="pageNum"
        :page-sizes="[2, 5, 10, 20]"
        :page-size="pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total"
      >
      </el-pagination>
    </div>

    <el-dialog title="用户信息" :visible.sync="dialogFormVisible" width="30%">
      <el-form label-width="80px" size="small">
        <el-form-item label="用户名">
          <el-input v-model="form.username" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="昵称">
          <el-input v-model="form.nickname" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="form.email" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="电话">
          <el-input v-model="form.phone" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="地址">
          <el-input v-model="form.address" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="save">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {contactApi} from "@/api";

export default {
  name: "FeedBackManage",
  data() {
    return {
      tableData: [],
      total: 0,
      pageNum: 1,
      pageSize: 2,
      username: "",
      domain_id: "",
      id: "",
      form: {},
      dialogFormVisible: false,
      multipleSelection: [],
    };
  },
  created() {
    this.load();
  },
  methods: {
    load() {
      contactApi.getFeebBackPage({
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          username: this.username,
          fbId: this.id,
          domainId: this.domain_id,
        },
      }).then((res) => {
        console.log(res.data);
        // 解析数据
        res = res.data;
        this.tableData = res.records;
        this.total = res.total;
      });
    },
    save() {
      contactApi.addUser(this.form).then((res) => {
        if (res) {
          // 弹出提示
          this.$message.success("保存成功");
          // 关闭弹窗
          this.dialogFormVisible = false;
          this.load();
        } else {
          this.$message.error("保存失败");
        }
      });
    },
    handleAdd() {
      this.dialogFormVisible = true;
      this.form = {};
    },
    handleEdit(row) {
      this.form = row;
      console.log(this.form)
      this.dialogFormVisible = true;
    },
    del(id) {
      console.log(id)
      contactApi.selectFeedBackById(id).then((res) => {
        if (res) {
          this.$message.success("精选成功");
          this.load();
        } else {
          this.$message.error("操作失败");
        }
      });
    },
    handleSelectionChange(val) {
      console.log(val);
      this.multipleSelection = val;
    },
    delBatch() {
      let ids = this.multipleSelection.map((v) => v.id); // [{}, {}, {}] => [1,2,3]
      contactApi.deleteUserBatchById(ids).then((res) => {
        if (res) {
          this.$message.success("批量删除成功");
          this.load();
        } else {
          this.$message.error("批量删除失败");
        }
      });
    },
    reset() {
      this.username = "";
      this.email = "";
      this.address = "";
      this.load();
    },
    handleSizeChange(pageSize) {
      console.log(pageSize);
      this.pageSize = pageSize;
      this.load();
    },
    handleCurrentChange(pageNum) {
      console.log(pageNum);
      this.pageNum = pageNum;
      this.load();
    },
  },
};
</script>

<style scoped>
.headerBg {
  background: #eee !important;
}
</style>
