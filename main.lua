-- 表示モード
-- 1:沸くまでの残りの時間表示
-- 2:沸く時間を表示
mode = 2;

-- 基準データ
SPAWN_TIME = {1323788460, 1323889260}

function OnInit()
  H.RegisterMenu("シューゴ流浪団", 2);
end

-- 執事のメニューが選択された場合
function OnMenu(id)
  -- 変数の局所化
  local now_time;

  -- メッセージのラベルの作成
  H.PlaySound(0, "r[1]rrrr[2]");

  -- 現在の時刻を取得
  now_time = os.time();

  -- 押されたボタンの判別
  if(id == 2) then
    shugo(now_time);
  end
end

function shugo(now)
  -- 変数の局所化
  local gtm;
  local gtd;
  local sec;
  local now_day;
  local spawn_day;
  local spawn_month;
  local day_message
  local time_date;
  local flag = false;

  -- ゲーム時間取得
  gtm = get_game_time_m(now);
  gtd = get_game_time_d(now);

  -- 出現チェック
  if(gtm % 3 ~= 1) then
    if(gtd == 15) or (gtd == 16) or (gtd == 17) then
      flag = true;
      H.Say(1, "今沸いてる可能\性があるにゃ");
    end
  end

  if(flag == false) then
    -- 残り時間の取得
    get_time(now, SPAWN_TIME[2]);

    -- 出現しない月の時間延長処理
    if(gtm % 3 == 1) then
      Day = Day + 2;
      Hour = Hour + 14;
      if(Hour >= 24) then
        Day = Day + 1;
        Hour = math.floor(Hour % 24);
      end
    end

    -- mode1
    if(mode == 1) then
      --時間出力
      H.Say(1,  Day .. "日 " .. Hour .. "時間 " .. Minute .. "分後");
    -- mode2
    elseif(mode == 2) then
      -- 出現時間表示
      sec = get_time_sec(Day, Hour, Minute);
      sec = sec + now;
      now_day = os.date("%d");
      spawn_day = os.date("%d", sec);
      spawn_month = os.date("%m", sec);
      day_message = spawn_day - now_day;
      time_date = os.date("%H時%M分", sec);

      if(day_message == 0) then
        day_message = "今日の";
      elseif(day_message == 1) then
        day_message = "明日の";
      elseif(day_message == 2) then
        day_message = "明後日の";
      else
        day_message = spawn_month .. "月" .. spawn_day .. "日 ";
      end

      --時間出力
      H.Say(1, day_message .. time_date .. "ごろ");
    end
    -- 文章出力
    H.Say(2, "シューゴ流浪団が出現するにゃん。");
  end
end

function get_time(now, bese_time)
  X = 223200 -  ((now - bese_time) % 223200);
  Day = math.floor(X / 86400);
  Hour = math.floor( (X - Day * 86400) / 3600 );
  Minute = math.floor( (X % 3600) / 60);
end

function get_game_time_m(now)
  local td;
  local gtm;

  td = now - SPAWN_TIME[1];
  gtm = math.floor(td / 223200);
  gtm = math.floor(gtm % 12);
  gtm = gtm + 1;

  return gtm;
end

function get_game_time_d(now)
  local td;
  local gtd;

  td = now - SPAWN_TIME[1];
  gtd = math.floor(td / 7200);
  gtd = math.floor(gtd % 31);
  gtd = gtd + 1;

  return gtd;
end

function get_time_sec(day, hour, min)
  local sec;

  sec = day * 86400;
  sec = sec + hour * 3600;
  sec = sec + min * 60;

  return sec;
end
