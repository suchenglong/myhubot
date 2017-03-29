# myhubot
我的hubot项目,这是用于我自己开发hubot插件的项目

# 主要功能
## 查询答案功能
读取一个aiml语料库文件,并使用hubot question (内容)的方式去语料库中查找对应的答案,目前只支持两种格式
```xml
<category>
    <pattern that="你 好">你 好 啊</pattern>
    <template>
        <random>
            <li>你好，我们刚刚说过一遍了。</li>
            <li>你好，客气啥！</li>
        </random>
    </template>
</category>
```
```xml
<category>
    <pattern>你 好 ， 我 是 *</pattern>
    <template>你好，很高兴认识 <star index="1"/>。 </template>
</category>
```
## 设置答案功能
使用如下命令设置答案,这个指令会蒋 问题|答案以如下方式存入文件中
```cmd
hubot setAnswer 问题|答案 的命令
```
```xml
<category>
    <pattern>你 好 ， 我 是 *</pattern>
    <template>你好，很高兴认识 <star index="1"/>。 </template>
</category>
```
