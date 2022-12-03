//
//  Loan.swift
//  MageMoney
//
//  Created by Benderson Phanor on 29/3/22.
//

import SwiftUI
import PencilKit

struct LoanItemView: View {
    var loan:Loan
    var typeInterest = ["Without","Simple","Compound"]
    var dateFormater: DateFormatter{
        let formater=DateFormatter()
        formater.dateStyle = .long
        return formater
    }
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Group{
                    Text(loan.name!)
                        .fontWeight(.bold)
                        
                    Spacer()
                    Text("\(loan.amount)".currencyFormatting())
                        .fontWeight(.bold)
                    Text((loan.currency?.isoCurrencyCode ?? " "))
                }
                .font(.caption)
                //.padding(.bottom)
                
            }
            Spacer()
            HStack{
                Text("\(typeInterest[Int(loan.interestType)]), \(Double(truncating: loan.interestRate!).percentFormatting())  M.")
                        .font(.caption2)

                    Spacer()
 
                Group{
                    Text(dateFormater.string(from:loan.deadline!))
                       
                    
                }.font(.caption)
            }
            Spacer()
            
            
        }
    }
}
/*
struct Loan_Previews: PreviewProvider {
    static var previews: some View {
        //LoanDetails(loan: Loan.loans.first!)
        LoanItemView(loan: Loan.loans.first!)
        //AddLoan()
    }
}
*/
struct LoanDetails: View {
    var loan:Loan
    var typeInterest=["without","Simple","compute"]
    @State var interestDetailIsShow = false
    @State var paidDetailIsShow = false
    @State var isShowCollectSheet=false
    var dateFormater: DateFormatter{
        let formater=DateFormatter()
        formater.dateStyle = .long
        return formater
    }
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
           
            
            Form{
                Section(header:Text("Borrower info")){
                    HStack{
                        Text("Full name:")
                        Spacer()
                        Text(loan.name!)
                    }
                    HStack{
                        Text("Sex:")
                        Spacer()
                        Text(loan.sex!)
                    }
                    HStack{
                        Text("Pasaporte:")
                        Spacer()
                        Text(loan.passport!)
                    }
                   // HStack{
                        
                        let now = Date()
                        if let birthday = loan.birthday{
                            let calendar = Calendar.current

                            let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
                            //let age = ageComponents.year!

                            HStack{
                                Text("Age:")
                                Spacer()
                                Text("\(ageComponents.year!) old")
                            }
                        }
                    //}
                    HStack{
                        Text("Email:")
                        Spacer()
                        Text(loan.email!)
                    }
                    HStack{
                        Text("Tel:")
                        Spacer()
                        
                        Text(loan.telephone!)
                    }
                }
                Section(header:Text("Loan info")){
                    HStack{
                        Text("Beginning:")
                        Spacer()
                        Text(dateFormater.string(from: loan.beginDate!))
                        
                    }
                    HStack{
                        Text("Amount:")
                        Spacer()
                        Text("\(String(loan.amount).currencyFormatting()) ")
                        Text((loan.currency?.isoCurrencyCode)!)
                    }
                    
                        HStack{
                            Text("Interest Type:")
                            Spacer()
                            Text(typeInterest[Int(loan.interestType)])
                        }
                    
                    HStack{
                        Text("Interest Rate:")
                        Spacer()
                        Text("\(Double( truncating: loan.interestRate! ).percentFormatting())")
                        let kk = ["monthly","yearly"]
                        Text(kk[Int(loan.timeInterest)])
                    }
                    HStack{
                        Text("Due:")
                        Spacer()
                        Text(dateFormater.string(from: loan.deadline!))
                    }
                    HStack{
                        Text("Current Amount:")
                        Spacer()
                        Text("\(String(loan.balance()).currencyFormatting()) ")
                        Text((loan.currency?.isoCurrencyCode)!)
                    }
                }
                
                Section(header:Text("Payment")){
                    HStack{
                        Text("Had to pay:")
                        Spacer()

                        /*let tiempo = loan.timeInterest == 0 ? Date().months(from: loan.beginDate!) : Date().years(from: loan.beginDate!)*/
                        
                        let interest = loan.interest() /*Double(loan.amount).interest(typeInteres: Int(loan.interestType), rate: Double(truncating: loan.interestRate!), tiempo: tiempo)*/
                        Button(action: {
                            if loan.interestType != 0{
                                interestDetailIsShow=true
                            }
                        }, label: {
                            HStack{
                                if loan.interestType != 0{
                                    Text("\(String(loan.balance()).currencyFormatting()) + \(String(interest).currencyFormatting()) ")
                                        .lineLimit(1)
                                }else{
                                    Text("\(String(loan.balance()).currencyFormatting()) ")
                                        .lineLimit(1)
                                }
                                Text((loan.currency?.isoCurrencyCode)!)
                            }
                        }).sheet(isPresented: $interestDetailIsShow){
                            VStack{
                                HStack{
                                    VStack(alignment: .leading){
                                        Text("Data")
                                        Text("Interest type: \(typeInterest[Int(loan.interestType)])")
                                        Text("Capital: \(String(loan.balance()).currencyFormatting())")
                                        Text("Rate: \(Double(truncating: loan.interestRate!).percentFormatting())")
                                        let kk = ["month","year"]
                                    
                                        HStack{
                                            
                                            Text("Time:")
                                            Text("(\(loan.beginDate!.prettyMedium()) - \(Date().prettyMedium()))")
                                                .font(.caption2)
                                                .lineLimit(1)
                                            //wrappedTimeInterest
                                            Text("  \(loan.wrappedTimeInterest) \(kk[Int(loan.timeInterest)])")
                                        }
                                        
                                        
                                        
                                    }
                                    Spacer()
                                }.padding()
                                VStack(alignment: .leading){
                                    
                                    if loan.interestType == 1{
                                       
                                        Text("Knowing that simple interest (I) = C*it")
                                        Text("I = \(loan.balance().pretty()) * \(loan.interestRate!) * \(loan.wrappedTimeInterest)")
                                    } else if loan.interestType == 2{
                                        Text("Knowing that compound interest (I) = C(1+i)ˆt")
                                        Text("I = \(loan.balance().pretty()) (1 + \(loan.interestRate!) )ˆ\(abs(loan.wrappedTimeInterest))")
                                    }
                                    
                                    Text("I = \(interest) ")
                                    Text("Final value or amount had to pay (fv)")
                                    Text("fv = \(loan.balance().pretty()) + \(interest)")
                                    let fv:String = (loan.balance()+interest).pretty()
                                    Text("fv = \(fv)")
                                    HStack{
                                        Text("fv = \(fv.currencyFormatting()) ")
                                        Text(loan.currency?.isoCurrencyCode ?? " ")
                                    }.padding()
                                }
                                Spacer()
                            }
                        }
                        .sheet(isPresented: $paidDetailIsShow){
                            PaymentDetail(loan: loan)
                        }
                    }
                    HStack{
                        Text("Payed:")
                        Spacer()
                        Button(action: {paidDetailIsShow=true}, label: {HStack{
                            Text( "\(payed(loan))".currencyFormatting() )
                            Text(loan.currency?.isoCurrencyCode ?? " ")
                        }})
                        
                    }
                }
                Section(header:Text("Signature")){
                    HStack{
                       
                        VStack{
                            if let dataImage=loan.signatureAtBeginnig{
                                Image(data: dataImage)?
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width*38/100, height: UIScreen.main.bounds.width*28/100)
                               // Image(uiImage: UIImage(data: ui)!)
                                
                            }
                            /*else{
                                Spacer()
                                Text("Empty")
                                Spacer()
                                    //.padding()
                            }
                            Text("At the beggining")
                                .font(.caption)
                                .padding(.bottom,5)*/
                        }//.frame(width: UIScreen.main.bounds.width*40/100)
                            .frame(minHeight: UIScreen.main.bounds.width*28/100)
                            
                        /*Divider()
                        VStack{
                            if let dataImage=loan.signatureWhenPaid{
                                Image(data: dataImage)?
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width*38/100, height: UIScreen.main.bounds.width*28/100)
                               // Image(uiImage: UIImage(data: ui)!)
                                
                            }
                            else{
                                Spacer()
                                Text("Empty")
                                Spacer()
                                    //.padding()
                            }
                            Text("When paid")
                                .font(.caption)
                                .padding(.bottom,5)
                        }.frame(width: UIScreen.main.bounds.width*40/100)
                            .frame(minHeight: UIScreen.main.bounds.width*28/100)*/
                        
                    }
                    
                }
                if let note = loan.note{
                    Section(header:Text("Note")){
                        HStack{
                            Text(note)
                            
                        }
                        
                    }
                }
            }
            
        }
        .sheet(isPresented: $isShowCollectSheet){
            
                VStack{
                    CollectView(loan: loan, isShow: $isShowCollectSheet)
                }
                 //  .presentationDetents([.large,.medium])
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: HStack{
            Button(action: { self.presentationMode.wrappedValue.dismiss() },label: {Image(systemName: "chevron.backward")
            })
        },trailing: HStack{
            Button(action: {
                isShowCollectSheet=true
              
            }, label: {
                Text("Collect")
                    .padding([.trailing])
                    
            })
        })
    }
    func payed(_ loan:Loan)->Double{
        return (loan.billing?.allObjects as! [Billing]).map({$0.amount}).reduce(0, +)
    }
}


struct AddLoan: View{
    //var loan:Loan
    @State var selectedCurrency=0
    @Environment(\.presentationMode) var presentationMode
    @State var name=""
    //@State var age="18"
    @State var passport=""
    @State var email=""
    @State var telephone=""
    @State var amount=""
    @State var note=""
    
    let tIS_1970 = Date().timeIntervalSince1970 - Date(timeIntervalSince1970: 3600*24*365*18).timeIntervalSince1970
    
    @State var birthDay=Date(timeIntervalSince1970: Date().timeIntervalSince1970 - Date(timeIntervalSince1970: 3600*24*365*18).timeIntervalSince1970 )
    @State var interestRate = "0.3"
    @State var pickerSexIndex=0
    @State var selectedAge=0
    @State var pickerInterestTypeIndex=0
    @State var beginningDate=Date()
    @State var deadLineDate=Date()
    @State var showSignature=false
    @State var timeInterest = 0
    //@State var isVisible = true
    //var ages:[Int]
    var dateFOrmater: DateFormatter{
        let formater=DateFormatter()
        formater.dateStyle = .long
        return formater
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity:Currency.entity(),sortDescriptors: [/*NSSortDescriptor(key:"name",ascending:true)*/])
    private var currencies: FetchedResults<Currency>
    
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    
    var body: some View{
        VStack{
            Form{
                Section(header: Text("Borrower info")){
                    TextField("Name",text: $name)
                    HStack {
                        //Text("Sex:")
                        Picker(selection: $pickerSexIndex, label: Text("Sex:")){
                            Text("Mal").tag(0)
                            Text("Femal").tag(1)
                            Text("No binary").tag(2)
                        }.pickerStyle(.menu)
                    }
                    
                    DatePicker(selection: $birthDay, in: ...Date(timeIntervalSince1970: tIS_1970),displayedComponents: .date){
                        Text("Birthday:")
                            .lineLimit(1)
                       
                    }
                    TextField("Passport",text: $passport)
                    TextField("Email",text: $email).keyboardType(.emailAddress)
                    TextField("Tel",text: $telephone).keyboardType(.phonePad)
                }
                Section(header: Text("Loan Info")){
                    DatePicker(selection: $beginningDate, in: ...Date(),displayedComponents: [.date,.hourAndMinute]){
                        Text("Beginning:")
                            .lineLimit(1)
                       
                    }
                    HStack{
                        TextField("Amount",text: $amount)
                            .keyboardType(.decimalPad)
                        Spacer()
                        Picker(selection: $selectedCurrency,label: Text("$")){
                            ForEach(0...currencies.count-1, id: \.self){//currency in
                                Text(" \(currencies[$0].isoCurrencyCode!) \(currencies[$0].countryFlag ?? " ") ")
                            }
                        }.pickerStyle(.menu)
                    }
                    
                    HStack {
                        Text("Interest Type:")
                        Picker(selection: $pickerInterestTypeIndex, label: Text("")){
                            Text("Without").tag(0)
                            Text("Simple").tag(1)
                            Text("Compound").tag(2)
                        }.pickerStyle(.menu)
                    }
                    if pickerInterestTypeIndex != 0{
                        HStack {
                            TextField("Interest Rate",text: $interestRate)
                            Spacer()
                            Picker(selection: $timeInterest, label: Text("")){
                                Text("Monthly").tag(0)
                                Text("Yearly").tag(1)
                            }.pickerStyle(.menu)
                        }
                    }
                    DatePicker(selection: $deadLineDate, in: Date()...,displayedComponents: [.date,.hourAndMinute]){
                        Text("Deadline day:")
                            .lineLimit(1)
                       
                    }
                   
                }
                Section(header: Text("Signature")){
               
                    Button(action: {showSignature.toggle()}, label: {
                            Text("Bowerrer signature")
                        })

                }
                Section(header: Text("Note")){
                    TextEditor(text:  $note)
                        .frame(minHeight:200)
                }
            }
            VStack(alignment: .leading){
                
                if showSignature{
                   /* HStack{
                        Button(action: {
                            isDraw.toggle()
                        }, label: {
                            Image(systemName: "pencil.tip.crop.circle.badge.plus")
                        }).padding(.leading)
                        
                       
                        
                        Button(action: {isDraw.toggle()}, label: {
                            Image(systemName: "pencil.tip.crop.circle.badge.minus")
                        }).padding(.leading)
                        Spacer()
                        Text("Add Signature")
                        Spacer()
                        Button(action: {showSignature.toggle()}, label: {
                            Text("Ok").padding(.top)
                        }).padding(.trailing)
                    }
                    DrawingView(canvas: $canvas, isDraw: $isDraw)
                        .frame(width: UIScreen.main.bounds.width,height: 200)
                        .padding(.bottom)*/
                    SignatureView(showBtnOk: true, isVisible: $showSignature, canvas:  $canvas)
                }
                    
            }.background(Color(UIColor(named: "bg_main")!))
        }.navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: HStack{
            Button(action: { self.presentationMode.wrappedValue.dismiss() }, label: {
                
                HStack{
                    Image(systemName: "chevron.backward")
                    Text("Cancel")
                        .padding([.leading])
                }
            })
        },trailing: HStack{
            Button(action: {
                addProduct()
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Save")
                    .padding([.trailing])
                    
            })
        })
    }
    
    private func saveContext(){
        do{
            try viewContext.save()
        }
        catch{
            let error = error as NSError
            fatalError("A error ocurred: \(error)")
        }
    }
    private func addProduct(){
        withAnimation{
            
            
            let loan = Loan(context: viewContext)
            let sex = ["Mal","Femal","No binary"]
            loan.name=name
            loan.sex=sex[pickerSexIndex]
            loan.signatureAtBeginnig=canvas.drawing.image(from: canvas.drawing.bounds, scale: 1).pngData()
            loan.amount=Double(truncating: NSDecimalNumber(string: amount))
            loan.note=note
            loan.passport=passport
            loan.birthday=birthDay
            loan.email=email
            loan.telephone=telephone
            loan.note=note
            loan.timeInterest = Int16(timeInterest)
            loan.interestType=Int16(pickerInterestTypeIndex)
            loan.interestRate=pickerInterestTypeIndex==0 ? 0 : NSDecimalNumber(string: interestRate)
            loan.beginDate = beginningDate
            loan.deadline = deadLineDate
            loan.currency=currencies[selectedCurrency]
            saveContext()
        }
   
}
    
    
}
struct DrawingView: UIViewRepresentable{
    @Binding var canvas: PKCanvasView
    @Binding var isDraw: Bool
    let eraser = PKEraserTool(.vector)
    let ink = PKInkingTool(.pen,color: .red)
    
    func makeUIView(context: Context) -> PKCanvasView  {
        canvas.drawingPolicy = .anyInput
        canvas.tool = isDraw ? ink : eraser
        return canvas
        
    }
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = isDraw ? ink : eraser
    }
}

extension Image {
    /// Initializes a SwiftUI `Image` from data.
    init?(data: Data) {
        #if canImport(UIKit)
        if let uiImage = UIImage(data: data) {
            self.init(uiImage: uiImage)
        } else {
            return nil
        }
        #elseif canImport(AppKit)
        if let nsImage = NSImage(data: data) {
            self.init(nsImage: nsImage)
        } else {
            return nil
        }
        #else
        return nil
        #endif
    }
}
