//
//  ContentView.swift
//  Shared
//
//  Created by Eizo Ishikawa on 2020/12/29.
//

import SwiftUI

struct ContentView: View {
    let date = Date()
    let dateFormatter = DateFormatter()
    let onColor = Color(red: 255 / 255, green: 51 / 255, blue: 153 / 255)
    let offColor = Color(red: 245 / 255, green: 245 / 255, blue: 245 / 255)
    let offColor_S = Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255)
    @State var colorArray = [[Bool]](repeating: [Bool](repeating: false, count: 19), count: 15)
    @State var exportAlert = false
    var body: some View {
        VStack(spacing: 5){
            HStack{
                Spacer()
                Text("iPad aided create Rina-chan board")
                    .font(.title)
                Spacer()
                Button(action: {
                        exportFile();
                        self.exportAlert = true
                }) {
                    Text("csv Export")
                        .accentColor(.blue)
                }.alert(isPresented: $exportAlert, content: {
                        Alert(title: Text("Export completely"))
                })
                Button(action:{resetColor()}) {
                    Text("Reset")
                        .accentColor(.red)
                }
                Spacer()
            }

            ForEach(1..<15){ i in
                HStack(spacing: 5){
                    ForEach(1..<19){ j in
                        RoundedRectangle(cornerRadius: 6)
                            .fill(decideColor(x: i, y: j))
                            .frame(width:45, height: 45)
                            .onTapGesture {
                                setColor(x: i, y: j)
                            }
                    }
                }
            }
        }
    }
    
    // Change the color by selection
    func decideColor(x: Int, y: Int) -> Color{
        if colorArray[x][y] == true{
            return onColor
        } else if y == 9 || y == 10{
            return offColor_S
        } else {
            return offColor
        }
    }

    // Change the color of array
    func setColor(x: Int, y: Int){
        print(colorArray[x][y])
        colorArray[x][y] = !colorArray[x][y]
        print("X = "+String(x)+" Y = "+String(y))
    }
    
    // Reset all colors
    func resetColor() {
        colorArray = [[Bool]](repeating: [Bool](repeating: false, count: 19), count: 15)
    }
    
    // Export to csv file
    func exportFile() {
        var text = ""
                for x in 1 ... 14{
                    for y in 1 ... 18{
                        if(colorArray[x][y]){
                            text += "1"
                        } else {
                            text += "0"
                        }
                        if y != 18{text += ", "}
                    }
                    text += "\n"
                }
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let fName = "RCB_" + dateFormatter.string(from: Date()) + ".csv"
        
        guard let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Failed to get directry.")
        }
        let fileURL = dirURL.appendingPathComponent(fName)
        do {
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
            
        } catch {
            print("Error: \(error)")
        }
        print("Export completely.")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
