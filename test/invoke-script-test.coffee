###
Copyright 2016 Hewlett-Packard Development Company, L.P.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing,
Software distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
###


nock = require 'nock'
Helper = require('hubot-test-helper')
chai = require 'chai'
expect = chai.expect


helper = new Helper([
  '../node_modules/hubot-enterprise/src/0_bootstrap.coffee',
  '../src/bpm-invoke-script.coffee'])

nock.disableNetConnect()
process.env.HUBOT_BPM_CONFIG_PATCH = "test/bpm-config-test.json"

describe 'invoke-script-test', ->
  @timeout 5000
  beforeEach (done) ->
    @room = helper.createRoom()
    setTimeout done, 1000

  afterEach ->
    @room.destroy()


  context 'Invoke specific script from specific BTF', ->
    beforeEach ->
      nocks = nock.load('test/rec-script-btf.json')

    it 'Responds to invoke script myDemoApp from btf myDemoApp', ->
      expectedResponse = 'Sorry currently only Slack is supported :('
      command = '@hubot bpm invoke script myDemoApp from btf myDemoApp from app demo for host myd-vm19775_london from London, UK location use bpm instance bpm_instance_1'
      @room.user.say('alice', command).then =>
        expect(@room.messages).to.eql [
          ['alice', command]
          ['hubot', 'Working on your request @alice, it may take some time.']
          ['hubot', expectedResponse]
        ]
        console.log(@room.messages.toString())

nock.cleanAll()
