<template>
  <div>
    <el-container>
      <el-main style="background-color: white;border: 1px solid purple;border-radius: 10px;margin-left: 10px">
<!--        <el-card class="box-card" shadow="hover" style="margin-top: 20px">-->

<!--        </el-card>-->
        <el-row>
          <el-col :span="8"><el-button @click="getGraphData">点击获取数据库数据</el-button></el-col>
          <el-col :span="8"><h2>节点标签总数：{{ nodeLen }}</h2></el-col>
          <el-col :span="8"><h2>关系类型总数：{{ relationshipLen }}</h2></el-col>
        </el-row>
        <el-card class="box-card-1" style="margin-top: 10px">
          <el-row>
            <h2>图谱信息</h2>
            <el-col :span="24"><div class="grid-content bg-purple-dark"></div></el-col>
          </el-row>
          <div id="main" style="width: 1200px; height: 85vh"></div>
          <el-table
            :data="tableData"
            border
            style="width: 100%">
            <el-table-column
              fixed
              prop="DomainName"
              label="域"
              width="210">
            </el-table-column>
<!--            <el-table-column-->
<!--              prop="name"-->
<!--              label="统计"-->
<!--              width="210">-->
<!--            </el-table-column>-->
            <el-table-column
              prop="NodeNumber"
              label="节点数"
              width="210">
            </el-table-column>
            <el-table-column
              prop="RelationshipNumber"
              label="关系数"
              width="210">
            </el-table-column>
            <el-table-column
              prop="address"
              label="简介">
            </el-table-column>
          </el-table>
        </el-card>
      </el-main>
    </el-container>

  </div>
</template>

<script>
import {kgBuilderApi} from "@/api";
import contactApi from "@/api/modules/contactApi";

export default {
  name: "Tongji",
  mounted() {
    // 初始化视图
    this.drawChart();
  },
  data() {
    return {
      NCDataList: {
        value1: 0,
        value2: 0,
        value3: 0
      },
      WCDataList: [],
      DataList: [],
      NodeDataList: '',
      x: '',
      graphdata: {
        node: '',
        relationship: '',
      },
      nodeLen: '',
      relationshipLen: '',
      tableData: [],
    }
  },
  methods: {
    getAllDataByList(data) {
      contactApi.getAllDataByList(data).then((res)=>{
        console.log("923749713925",res)
        this.tableData = res.data
        var i = 0
        var strArr1 = ["数", "代数", "几何", "集合", "矩阵", "分析"]
        var strArr2 = ["Java", "Python", "IT", "系统", "数据库", "计算机", "组成原理"]
        for (; i < res.data.length; i++) {
          var Number = res.data[i].NodeNumber +  res.data[i].RelationshipNumber
          var Name = res.data[i].DomainName
          this.WCDataList[i] = {value: Number ,name: Name}
          // Math
          if (res.data[i].DomainName.includes("数")){
            this.NCDataList.value1 += Number
          }
          // CS
          if (res.data[i].DomainName.includes("Java")){
            this.NCDataList.value2 += Number
          }
          if (res.data[i].DomainName.includes("IT")){
            this.NCDataList.value2 += Number
          }
          //Other
          this.NCDataList.value3 = this.nodeLen + this.relationshipLen - this.NCDataList.value1 - this.NCDataList.value2
        }
      })
    },
    getAllDataForTJ() {
      contactApi.getAllDataForTJ().then((res)=>{
        let list = []
        var i = 0
        for (; i < res.data.node.length; i++) {
          list[i] = res.data.node[i].label.replace("\"","").replace("\"","")
        }
        this.DataList = list
        var arr = Array.from(this.DataList)
        var i = 0
        for (; i < arr.length; i++) {
          if (arr[i].indexOf("@") > -1){
            var index = arr[i].indexOf("@");
            arr[i] = arr[i].substring(0, index);
          }
        }
        this.NodeDataList = arr
      })
    },
    getGraphData() {
      kgBuilderApi.getGraphData().then((res) => {
        this.graphdata = res.data
        this.nodeLen = this.graphdata.node.length
        this.relationshipLen = this.graphdata.relationship.length
        this.getAllDataForTJ()
        let data = {domainNameList: this.DataList }
        this.getAllDataByList(data)
        this.drawChart()
      })
    },
    drawChart() {
      console.log(this.NodeDataList[1])
      // 基于准备好的dom，初始化echarts实例  这个和上面的main对应
      let myChart = this.$echarts.init(document.getElementById("main"));
      // 指定图表的配置项和数据
      let option = {
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          data: this.NodeDataList,
        },
        series: [
          {
            name: '属于',
            type: 'pie',
            selectedMode: 'single',
            radius: [0, '30%'],
            label: {
              position: 'inner',
              fontSize: 12
            },
            labelLine: {
              show: false
            },
            data: [
              { value: this.NCDataList.value1, name: 'Math' },
              { value: this.NCDataList.value2, name: 'CS', selected: true },
              { value: this.NCDataList.value3, name: 'Other' }
            ]
          },
          {
            name: '源自于',
            type: 'pie',
            radius: ['45%', '60%'],
            labelLine: {
              length: 30
            },
            label: {
              formatter: '{a|{a}}{abg|}\n{hr|}\n  {b|{b}：}{c}  {per|{d}%}  ',
              backgroundColor: '#F6F8FC',
              borderColor: '#8C8D8E',
              borderWidth: 1,
              borderRadius: 4,
              rich: {
                a: {
                  color: '#6E7079',
                  lineHeight: 22,
                  align: 'center'
                },
                hr: {
                  borderColor: '#8C8D8E',
                  width: '100%',
                  borderWidth: 1,
                  height: 0
                },
                b: {
                  color: '#4C5058',
                  fontSize: 14,
                  fontWeight: 'bold',
                  lineHeight: 33
                },
                per: {
                  color: '#fff',
                  backgroundColor: '#4C5058',
                  padding: [3, 4],
                  borderRadius: 4
                }
              }
            },
            data: this.WCDataList
          }
        ]
      };
      // 使用刚指定的配置项和数据显示图表。
      myChart.setOption(option);
    },
    handleClick(row) {
      console.log(row);
    }
  },
  computed: {

  },
};
</script>

<style scoped></style>
